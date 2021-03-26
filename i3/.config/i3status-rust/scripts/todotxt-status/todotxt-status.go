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
	Todotxt = "/Dropbox/todotxt/todo.txt"
	Donetxt = "/Dropbox/todotxt/done.txt"
  Done = "▰"
  NotDone = "▱"
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

func getLinesBy(file []byte, substr string) []string {
	var lines []string
	for _, todo := range strings.Split(string(file), "\n") {
		if strings.Contains(todo, substr) {
			lines = append(lines, todo)
		}
	}
	return lines
}

func getProgrssBar(done int, total int) string {
  var full string
  var empty string
  for i := 0; i < done; i++ {
    full += Done
  }
  for i := 0; i < total - done; i++ {
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
	date := time.Now().Format("2006-01-02")
	leftToday := len(getLinesBy(todofile, "(B)"))
	doneToday := len(getLinesBy(donefile, date))
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
