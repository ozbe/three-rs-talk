
# Presentation

## Slides

[the-three-rs.key](./the-three-rs.key)

## Cargo Package

### Prep

None

### Steps

```
$ cargo new cargo-serde-example
$ cd cargo-serde-example
```

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

## evcxr

### Prep

Open a terminal and enter in all of the values before the presentation

### Steps

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

Show jupyter

## runner

### Prep

Remove serde with `runner edit`

### Steps

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

Show starter

Add content

```
runner -s runner-serde-example.rs
```

## cargo-eval

### Prep

None

### Steps

Show starter

Add content

```bash
$ cargo eval cargo-eval-serde-example
```