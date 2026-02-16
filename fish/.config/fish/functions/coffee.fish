function coffee --description "Print ASCII coffee and prevent sleep for 2 hours"
    printf '%s\n' \
        '   ( (' \
        '    ) )' \
        '  ........' \
        '  |      |]' \
        '  \      /' \
        "   '----'"

    if not command -q caffeinate
        echo "coffee: 'caffeinate' command not found" >&2
        return 127
    end

    set -l running_pids
    for pid in (pgrep -x caffeinate)
        set -l cmd (ps -o command= -p $pid)
        if string match -rq '(^|/)caffeinate( |$)' -- $cmd; and \
           string match -rq '(^| )-dimsu( |$)' -- $cmd; and \
           string match -rq '(^| )-t( |$)7200( |$)' -- $cmd
            set running_pids $running_pids $pid
        end
    end

    if test (count $running_pids) -gt 0
        if kill $running_pids
            echo "coffee: stopped existing caffeinate process(es): "(string join ", " $running_pids)
        else
            echo "coffee: found existing caffeinate process(es), but failed to stop all: "(string join ", " $running_pids) >&2
            return 1
        end
        return 0
    end

    caffeinate -dimsu -t 7200 $argv
end
