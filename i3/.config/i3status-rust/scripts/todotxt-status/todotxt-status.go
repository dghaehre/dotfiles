package main

import (
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/user"
	"strings"
	"time"
)

const (
	Folder    = "/Dropbox/todotxt/"
	Todotxt   = Folder + "todo.txt"
	Donetxt   = Folder + "done.txt"
	Done      = "▰"
	NotDone   = "▱"
	Checkmark = "✓"
)

type Result struct {
	Icon  string `json:"icon"`
	Text  string `json:"text"`
	State string `json:"state"`
}

func printResult(result Result) {
	res, err := json.Marshal(result)
	if err != nil {
		return
	}
	fmt.Println(string(res))
}

func emptyResult() Result {
	var result Result
	result.Text = ""
	result.State = "Idle"
	return result
}

func conflictedCopyResult() Result {
	var result Result
	result.Text = "TODO.txt has conflict"
	result.State = "Critical"
	return result
}

func hasConflictedCopies(folder string) (bool, error) {
	conflictExists := false
	files, err := os.ReadDir(folder)
	if err != nil {
		return conflictExists, err
	}
	for _, file := range files {
		if strings.Contains(file.Name(), "conflicted") {
			conflictExists = true
		}
	}
	return conflictExists, nil
}

func getLinesBy(file []byte, substr string) []string {
	var lines []string
	for _, todo := range strings.Split(string(file), "\n") {
		if strings.Contains(todo, substr) {
			lines = append(lines, todo)
		}
	}
	return lines
}

func removeFutureTasks(now time.Time, lines []string) []string {
	var newlines []string
	for _, line := range lines {
		split := strings.Split(line, " t:")
		if len(split) == 1 {
			newlines = append(newlines, line)
			continue
		}
		linedate, err := time.Parse("2006-01-02", split[1])
		if err == nil && now.Before(linedate) {
			continue
		}
		newlines = append(newlines, line)
	}
	return newlines
}

func getProgrssBar(done int, total int) string {
	var full string
	var empty string
	for i := 0; i < done; i++ {
		full += Done
	}
	for i := 0; i < total-done; i++ {
		empty += NotDone
	}
	return full + empty
}

func workingNow(file []byte) (Result, error) {
	nows := getLinesBy(file, "(A)")
	if len(nows) == 1 {
		var result Result
		result.Text = strings.Replace(nows[0], "(A)", "", 1)
		result.Icon = "headphones"
		result.State = "Info"
		return result, nil
	}
	return emptyResult(), errors.New("no working now..")
}

func checkProgress(todofile []byte, donefile []byte) Result {
	result := emptyResult()
	now := time.Now()
	date := now.Format("2006-01-02")
	leftToday := len(removeFutureTasks(now, getLinesBy(todofile, "(B)")))
	doneToday := len(removeFutureTasks(now, getLinesBy(donefile, " " + date + " ")))
	total := leftToday + doneToday
	if leftToday > 0 {
		result.Icon = "tasks"
		result.Text = getProgrssBar(doneToday, total)
		return result
	}
	if total > 0 {
		result.Text = Checkmark + " " + fmt.Sprint(doneToday)
		result.State = "Good"
		return result
	}
	result.Icon = "tasks"
	result.Text = "no tasks today"
	return result
}

func main() {
	var verbose bool
	flag.BoolVar(&verbose, "v", false, "Print debug information")
	flag.Parse()

	usr, err := user.Current()
	if err != nil {
		if verbose {
			fmt.Println(err)
		}
		printResult(emptyResult())
		return
	}

	if verbose {
		date := time.Now().Format("2006-01-02")
		fmt.Println(date)
	}

	conflictedCopy, err := hasConflictedCopies(usr.HomeDir + Folder)
	if err != nil {
		if verbose {
			fmt.Println(err)
		}
	}

	if conflictedCopy == true {
		printResult(conflictedCopyResult())
		return
	}

	todoFile, err := os.ReadFile(usr.HomeDir + Todotxt)

	if err != nil {
		if verbose {
			fmt.Println(err)
		}
		printResult(emptyResult())
		return
	}

	now, err := workingNow(todoFile)
	if err == nil {
		printResult(now)
		return
	}

	// TODO: read file in chunks (bottom-up)
	doneFile, err := os.ReadFile(usr.HomeDir + Donetxt)
	if err != nil {
		if verbose {
			fmt.Println(err)
		}
		printResult(emptyResult())
		return
	}

	printResult(checkProgress(todoFile, doneFile))
}
