import * as io from "https://deno.land/std@0.100.0/io/mod.ts";

let index = 0;
const utf8Encoder = new TextEncoder();

async function send(message: string): Promise<void> {
  index += 1;
  const data = [message.length, message];
  const command = ["call", "vim_channel_test#verify", data, index * -1];
  await io.writeAll(
    Deno.stdout,
    utf8Encoder.encode(JSON.stringify(command) + "\n"),
  );
}

async function consumer(): Promise<void> {
  for await (const line of io.readLines(Deno.stdin)) {
    console.error(line);
  }
}

async function producer(): Promise<void> {
  let message = "0123456789";
  for (let i=0; i<10; i++) {
    await send(message);
    console.error(`Sent ${message.length} characters`);
    message = message.repeat(10);
  }
  Deno.stdin.close();
}

await Promise.race([consumer(), producer()]);
