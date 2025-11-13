import type { FinickyConfig } from "/Applications/Finicky.app/Contents/Resources/finicky.d.ts";

const apps = [
  "com.figma.Desktop", // Figma
  "com.linear", // Linear
  "notion.id", // Notion
  "com.tinyspeck.slackmacgap", // Slack
];

export default {
  defaultBrowser: "Safari",

  handlers: [
    {
      match: /youtube\.com/,
      browser: {
        name: "Safari",
      },
    },
    {
      match: /notion\.so/,
      browser: {
        name: "ChatGPT Atlas",
      },
    },
    {
      match: /figma\.com\/(file|design)/,
      browser: {
        name: "ChatGPT Atlas",
      },
    },
    {
      match: /https:\/\/mcp\.linear\.app\/authorize/,
      browser: {
        name: "ChatGPT Atlas",
      },
    },
    {
      match: /linear\.app/,
      browser: {
        name: "ChatGPT Atlas",
      },
    },
    {
      match: /meet\.google\.com/,
      browser: (url) => ({
        name: "Google Chrome", // Google Chrome 経由で Goog Meet を開くことで正しく URL が連携される
        args: [
          "--app-id=kjgfgldnnfoeklkmfkjfagphfepbbdan", // chrome://web-app-internals/ から確認可能
          `--app-launch-url-for-shortcuts-menu-item=${url}`,
        ],
        profile: "work",
      }),
    },
    {
      match: [/^https?:\/\/localhost:.*$/],
      browser: {
        name: "Google Chrome",
        profile: "work",
      },
    },
    {
      match: (_, options) => apps.includes(options?.opener?.bundleId ?? ""),
      browser: {
        name: "ChatGPT Atlas",
      },
    },
  ],
} satisfies FinickyConfig;
