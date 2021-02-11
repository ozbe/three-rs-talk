# evcxr_jupyter

```
$ docker build -t ozbe/evcxr_jupyter .
$ docker run -p 8888:8888 -v $(pwd)/work:/home/jovyan/work ozbe/evcxr_jupyter
# Open the `127.0.0.1:8888` line of the output in your browser
# "New > Rust"
```

## References

* [Interactive Rust in a REPL and Jupyter Notebook with EVCXR](https://depth-first.com/articles/2020/09/21/interactive-rust-in-a-repl-and-jupyter-notebook-with-evcxr/)