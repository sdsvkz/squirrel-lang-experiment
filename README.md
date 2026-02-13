## How to run

Get a copy of Squirrel interpreter `sq`, make sure it is on `PATH`

Open a shell and `cd` to this directory

You can run files with suffix `.entry.nut`

To run `main.entry.nut`:

```shell
sq main.entry.nut
```

To run tests, for example, `plant/test/testPlant.entry.nut`:
```shell
sq plant/test/testPlant.entry.nut
```

## File naming convention

- `.nut`: Returns a callable (function or table with metamethod `_call`)
- `.class.nut`: Returns a class
- `.enum.nut`: Returns a table as an enum
- `.module.nut`: Returns a table contains exported items
- `.entry.nut`: Runnable files
