# DiscordBotHx

This is, as you already know if you read the description, a framework to create a bot for Discord using [DiscordJS](https://github.com/hydrabolt/discord.js) with [Haxe](http://haxe.org/).

## History
Haxe is a strict meta language. That means you can code in Haxe and compile your code in other languages such as JavaScript. So I decided to create a bot using the DiscordJS library and Haxe. But this language has a strict compiler, and you can't just go "Yeah, instanciate Discord.Client, don't worry, I know what I'm doing!". You have to explain him how to work with the library using externs. That's what [DiscordHx](https://github.com/ElianWonhalf/DiscordHx) is about. With DiscordBotHx (which uses, you guessed it, DiscordHx), you have the "boring" part of creating a Discord bot already done.

## Installation
You can either set DiscordBotHx as a dependency in your package.json, or you can clone this repository and execute `npm install`.

Now, you need to go in the `test/auth` folder and make a copy of `AuthDetails_example.hx` that you will name `AuthDetails.hx`. Open this file and fill it with your Discord API credentials. You can also add your [CleverbotIO](https://cleverbot.io/) credentials if you have some.

Then, you can run `npm run test` to compile the example bot. A `bot.js` file will be in the `out` folder. All that you need to do is run `node --harmony out/bot.js`, and the bot will be launched.

## Contribution
Feel free to leave issues or to make pull requests! You can also contact me at elianwonhalf@gmail.com.