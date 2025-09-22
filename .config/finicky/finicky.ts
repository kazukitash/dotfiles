import type { FinickyConfig } from "/Applications/Finicky.app/Contents/Resources/finicky.d.ts";

export default {
  defaultBrowser: "Google Chrome",

  handlers: [
    {
      match: [/^https?:\/\/localhost:.*$/],
      browser: {
        name: "Google Chrome Beta",
        profile: "Default",
      },
    },
    {
      match: /notion\.so/,
      browser: "Notion",
    },
    {
      match: /figma\.com\/(file|design)/,
      browser: "Figma",
    },
    {
      match: /linear\.app/,
      browser: "Linear",
    },
  ],
} satisfies FinickyConfig;
