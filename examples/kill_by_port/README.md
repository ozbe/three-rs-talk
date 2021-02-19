# Kill (Process) By Port

`cargo-eval` version of running:
```
$ lsof -i :[PORT]
$ kill -9 [PID]
```

Start server
```
$ ./server.crs
```

Verify the server is running
```
$ open http://localhost:4000/
```

Stop the server process using the port number
```
$ ./kill_by_port.crs 4000
```

## References

* [Command Line Cheat Sheet](https://ozbe.io/command-line-cheat-sheet/#track-process-by-port-and-kill-said-process)