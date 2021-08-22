import * as io from "https://deno.land/std@0.100.0/io/mod.ts";

try {
  for await (const line of io.readLines(Deno.stdin)) {
    const [msgid, data] = JSON.parse(line);
    console.error(`Recv ${msgid} ${data.length}`);
  }
} catch (e) {
  console.error(`Error: ${e}`);
}
console.error(`Close`);
