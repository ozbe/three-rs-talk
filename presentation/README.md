
# Presentation

### Prep

#### evcxr

Start jupyter

```
docker run -d -p 8888:8888 -v $(pwd)/work:/home/jovyan/work ozbe/evcxr_jupyter
```

open in tab with token and close said tab

#### Runner
Remove serde with `runner --edit`

## Slides

[the-three-rs.key](./the-three-rs.key)

### Title (Slide 1)

/me read title

I'm Josh Aaseby

I'm a Rust hobbyist and this is actually my first Melbourne Rust Meet up, so thanks for having me.

### Outline (Slide 2)

Don't worry about screen capturing or frantically copying down what you see, I'll share the slides and examples after the presentation

### Problem Statement (Slide 3)

I'm sure many of you, like me, have found yourself going through the same steps when evaluating a new dependency:

```
    Do you have a pre-existing applicable project in source control?
        Yes, create a branch
        No, create a new Cargo package
    Then you add the dependency to Cargo.toml
    Change some relevant code to try something out about the library
    Build
    Run
    Do I have everything I need to know to make a decision about the library
        Yes, go do what I need to do
        No, go back working on the code
```

I am going to talk about two types of tools to help reduce this overhead and increase our iteration time.

### REPLs (Slide 4)

The first is REPLs

For the uninitiated REPLS are...

Here are a few Rust examples

The bold example we'll talk about later

### Runners (Slide 5)

The other type of tool is a Runner

A Runner is...

Here a few Rust runner examples

Definitions and names are nice and all, but let's compare a few of them with an example

### Code example

The example were going to use across the tools is serialize and deserialize a custom struct to and from JSON with Serde

This example is taken from the serde_json docs. 

Take a moment to read it. 

Don't worry too much about groking it. 

Just know that we are using a dependency and that we should get a similar output from each tool

So let's get to the code

/me switch to VS code

## Cargo Package

### Steps

Before we get to the tools, let's make a new cargo package for a baseline
```
cd presentation/start
cargo new cargo-serde-example
cd cargo-serde-example
```

Now we open the Cargo.toml and add serden and serde_json
```toml
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
```

With the proper dependencies, change `./src/main.rs` to match the code below:
```rust
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct Point {
	x: i32,
	y: i32,
}

fn main() {
	let point = Point { x: 1, y: 2 };
	let serialized = serde_json::to_string(&point).unwrap();
	println!("serialized = {}", serialized);
	let deserialized: Point = serde_json::from_str(&serialized).unwrap();
	println!("deserialized = {:?}", deserialized);
}
```

Finally, we can run the package:
```
cargo run
```

Now I know this isn't a REPL or runner, but I want to share this as our baseline.

Now that we've made a cargo package, let's try the example in a REPL

## evcxr

### Steps

The REPL we are going to use is evcxr

/me show GitHub page

/me go to VS code

```
evcxr
```

Similar to the cargo package, we will add our dependencies

```
:dep serde = { version = "1.0", features = ["derive"] }
:dep serde_json = { version = "1.0" }
```

This syntax is specific to the REPL, but it should look familiar

With our dependencies we then enter the example in one line at a time 

```
use serde::{Serialize, Deserialize};
#[derive(Serialize, Deserialize, Debug)]
struct Point {
    x: i32,
    y: i32,
}
let point = Point { x: 1, y: 2 };
let serialized = serde_json::to_string(&point).unwrap();
println!("serialized = {}", serialized);
let deserialized: Point = serde_json::from_str(&serialized).unwrap();
println!("deserialized = {:?}", deserialized);
```

And done. Same output. Now each session of the REPL of independent of one another and when you close the session the state is cleared.

If you're looking to resume your work you can leverage the REPL's jupyter notebook support

```
open http://127.0.0.1:8888
```

/me New > Rust

```
println!("Hello, meetup")
```

## runner

### Steps

First we need to add serde to runner's static cache
```bash
runner --edit
```

```toml
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
```

Save the file and now we will rebuild the static cache:
```bash
runner --build
```

Now I have a starter file for the runner

/me show starter presentation/start/runner-serde-example.rs

/me add content

```
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let point = Point { x: 1, y: 2 };
    let serialized = serde_json::to_string(&point).unwrap();
    println!("serialized = {}", serialized);
    let deserialized: Point = serde_json::from_str(&serialized).unwrap();
    println!("deserialized = {:?}", deserialized);
}
```

and let's run

```
runner -s runner-serde-example.rs
```

The `-s` necessary so we can use the Serde crates we added to the static cache earlier.

## cargo-eval

### Steps

The last tool I'm going to show is cargo-eval

/me show github page

cargo-eval is a Runner and works similar to the previous tool we saw

Let's jump into a starter for cargo eval to try it out

/me Show starter presentation/start/cargo-eval-serde-example.rs

You can see cargo-eval manages dependencies a little differently. They are included in a comment at the top of the file.

/me add content
```
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let point = Point { x: 1, y: 2 };
    let serialized = serde_json::to_string(&point).unwrap();
    println!("serialized = {}", serialized);
    let deserialized: Point = serde_json::from_str(&serialized).unwrap();
    println!("deserialized = {:?}", deserialized);
}
```

And run

```
cargo eval cargo-eval-serde-example
```

Those are 3 tools you can use instead of cargo. 

As much as I enjoy serde, I want to show you a few more practical examples of cargo-eval.

## Examples

### file server

The first is a file server script

/me show file file_server.crs

```
cargo eval file_server.crs 
```

```
curl http://127.0.0.1:3030/static/README.md
```

### kill by port

For the next example, have you ever seen a port in use error when trying to start a service?

I wrote a script to find the process by port and kill it.

First, let's start a server

```
./server.crs
```


```
open http://localhost:4000/
```

Now let's kill the server by the port
```
./kill_by_port.crs 4000
```

Let's make sure it stopped

/me refresh browser

### k8s_ingress
Next is an example of just because you can, doesn't mean you should

/me show k8s_ingress.sh

I have a bash script to open a kubernetes ingress in my browser

I've rewritten it in Rust

/me show k8s_ingress.crs

Quite a bit more code. 

Something like this may be more useful if you had shared code or libraries

### hq

These exmaples have been fairly small, but the scripts can be as complex as you can tolerate.

Here is a utility I wrote that uses css selectors to extract html

/me show hq.crs

Let's run it on an example html file

/me show example.html

```
./hq.crs 'h1' < example.html
```

There you are

/me go back to slides

That concludes the examples

Ways to find me

Link to talk at the bottom. As I mentioned I'll share the link after the presentation

Thank you for your time and now I'll open the chat to questions