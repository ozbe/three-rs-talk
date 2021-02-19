# The Three "R"s: Rust, REPL, Runner

REPLs and runners can be a quick and easy way to iterate and execute code. Let's try different Rust REPLs & runners to see the differences between each tool.

## Intro
tl;dr [Jump to the code](#cargo-project)

When evaluating a new dependency I often find myself going through the same steps:
1. Do I have a pre-existing applicable project in source control?
	1. Yes, create a branch
	2. No, create a new Cargo package
2. Add the dependency to `Cargo.toml`
3. Change some relevant code to try something out about the library
4. Build
5. Run
6. Do I have everything I need to know to make a decision about the library
	1. Yes, go do what I need to do
	2. No, go back to Step 3

These steps can grow tedious, especially when needing to create a new cargo package. The iterations can be shortened by more work up front looking at documentation, source, and examples. But sometimes you just want to experiment in a quick and efficient way. That is when REPLs and runners can prove to be helpful.

For the uninitiated, a REPL (Read, Evaluate, Print, Loop) is typically an interactive shell that takes user input, evaluates said input, and returns the result.  Assuming I can access the required dependencies, I should be able to take the contents of the `fn main()` above and enter each expressions in line-by-line into a REPL.

There isn’t an [official REPL](https://github.com/rust-lang/rfcs/issues/655), but there is at least one active community REPL:
* [Evcxr REPL](https://github.com/google/evcxr/blob/master/evcxr_repl/)

A Rust runner allows you to run (well, compile, link, _and_ run) Rust code without the overhead (and benefits) of creating a Cargo package. 

Similar to the REPL, there isn’t an official Rust runner, besides Cargo, but there are a few community options:
* [runner](https://github.com/stevedonovan/runner)
* [cargo-eval](https://github.com/reitermarkus/cargo-eval)

Now that we have a better idea of the landscape, let’s implement the same Rust example with these tools. 

Our example will use `serde_json` to print a serialized and deserialized `Point` struct.

## Cargo Package
To start, we will create a Cargo package as a baseline. 

Create a new cargo package and move into the package directory:
```bash
$ cargo new cargo-serde-example
$ cd cargo-serde-example
```

Next, lets add the Serde dependencies we’ll need to the bottom of the `Cargo.toml` under `[dependencies]`:
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
```bash
$ cargo run
```

You should see the following at the bottom of the output:
```
serialized = {"x":1,"y":2}
deserialized = Point { x: 1, y: 2 }
```

Now with our baseline, we can try the REPLs and runners.

## Evcxr REPL
[Evcxr REPL](https://github.com/google/evcxr/blob/master/evcxr_repl/) is a REPL for Rust that uses the [evcxr](https://github.com/google/evcxr/blob/master/evcxr/README.md) execution context. For our purposes, we don’t need to go into depth how `evcxr` works, let’s just get things setup and run.

### Setup
Before you install the REPL, you must download a local copy of Rust's source code:
```bash
$ rustup component add rust-src
```

Now you can go ahead and install the binary:
```bash
$ cargo install evcxr_repl
```

Source: [evcxr/README.md at master · google/evcxr · GitHub](https://github.com/google/evcxr/blob/master/evcxr_repl/README.md#installation-and-usage)

### Run
Enter the following lines in the REPL (without the `>> `) to get the _same_ output as the Cargo package :
```bash
$ evcxr
>> :dep serde = { version = "1.0", features = ["derive"] }
>> :dep serde_json = { version = "1.0" }
>> use serde::{Serialize, Deserialize};
>> #[derive(Serialize, Deserialize, Debug)]
struct Point {
    x: i32,
    y: i32,
}
>> let point = Point { x: 1, y: 2 };
>> let serialized = serde_json::to_string(&point).unwrap();
>> println!("serialized = {}", serialized);
>> let deserialized: Point = serde_json::from_str(&serialized).unwrap();
>> println!("deserialized = {:?}", deserialized);
```

A few things to note about the REPL session:
1. `:dep` lines are equivalent to the `[dependencies]` section of the `Cargo.toml` in the Cargo package
2. The session does not end until we exit the REPL. We can continue to work with the previous lines until we exit or the REPL is reset.

It isn’t hard to imagine how this REPL session would be useful when exploring the functionality of an API or doing some one-off work. Remember to save you session (copy and paste) before closing out of the REPL, otherwise your work may be lost.

Unfortunately, if you want to run previously written code in the REPL, you have to enter the code in one statement at a time. Running code in different sessions is where runners come into play.

## runner
[runner](https://github.com/stevedonovan/runner) compiles, links, and runs a Rust script (or snippet) without the boilerplate Cargo package. Let’s setup `runner` and run our example to see how it works with a script.

### Setup
```bash
$ cargo install runner
``` 

### Run
First we need to add the Serde dependencies to `runner`’s static cache (just trust me). Run the following command to add `serde` and initialize the static cache:
```bash
$ runner add serde
```

Now we will edit the static cache manually:
```bash
$ runner edit
```

At the bottom of the file you will see:
```toml
serde="*"
```

Replace `serde=“*”` with:
```toml
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
```

Save the file and now we will rebuild the static cache:
```bash
$ runner --build
```

The dependencies are now available for our `runner` script that we are now going to create. 

Copy the following contents to a new file named `runner-serde-example.rs`:
```rust
extern crate serde_json;
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

Finally, run the script:
```bash
$ runner -s runner-serde-example.rs
serialized = {"x":1,"y":2}
deserialized = Point { x: 1, y: 2 }
```

The `-s`  in the command tells `runner` to “evaluate expressions against crates compiled as static libraries.” This is necessary so we can use the Serde crates we added to the static cache earlier.

In addition to running scripts, `runner` also supports running expressions, similar to running one statement in a REPL. 
Here is an example using the `serde_json` dependency we added earlier to deserialize an `Object` from a string of JSON text:
```
$ runner -s -Xserde_json -e 'serde_json::from_str::<serde_json::Value>(r#"{"foo":"bar"}"#).unwrap()'
Object({"foo": String("bar")})
```

Managing the dependencies with `runner` can be somewhat cumbersome. Script dependencies are managed outside the script and only one version of crate can be added to the static cache at a time.
`cargo-eval` is another runner that has a different solution to managing dependencies and similar features to `runner`.

## cargo-eval
[cargo-eval](https://github.com/reitermarkus/cargo-eval) is a Cargo subcommand that enables you to run Rust scripts (or expressions). Let’s setup `cargo-eval` and run our example to see how it works with a script.

### Setup
```bash
$ cargo install cargo-eval
```

### Run
Create a new file called  `cargo-eval-serde-example.rs` and copy in the following script contents:
```rust
//! ```cargo
//! [dependencies]
//! serde = { version = "1.0", features = ["derive"] }
//! serde_json = "1.0"
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

The first line of `cargo-eval-serde-example.rs` denotes the start of a partial Cargo manifest. In this section you can configure dependencies and manifest information. The rest of the script should look familiar at this point. We have all we need for our example, so let’s run the script.

Run the script with:
```bash
$ cargo eval cargo-eval-serde-example
...
serialized = {"x":1,"y":2}
deserialized = Point { x: 1, y: 2 }
```

In addition to running scripts, `cargo-eval` includes other features, such as running benchmarks and tests.

## Conclusion
We have now implemented the same example with a Cargo project, a REPL, and two runners. 
Hopefully you feel more comfortable with each tool and have some ideas of when you can use them to decrease your iteration speed and improve your workflow.

We just touched on the capabilities these different tools. You should check out each tool to see the full list of features and options.

For more examples implemented with these tools, check out [GitHub - ozbe/rust-repls-and-runners: A collection of examples implemented with different Rust REPLs & Runners.](https://github.com/ozbe/rust-repls-and-runners)

If you have any questions on what was covered or have any thoughts or experiences with these tools, please share them in the comments!

## Updates

### 2020-02-13

A few more runners and REPLs:
* [fanzeyi/cargo-play](https://github.com/fanzeyi/cargo-play) - A local Rust playground
* [fornwall/rust-script](https://github.com/fornwall/rust-script) - Run Rust files and expressions as scripts without any setup or compilation step.
* [murarth/rusti](https://github.com/murarth/rusti) - (Deprecated) REPL for the Rust programming language
* [kurtlawrence/papyrus](https://github.com/kurtlawrence/papyrus) - (Deprecated) Rust REPL