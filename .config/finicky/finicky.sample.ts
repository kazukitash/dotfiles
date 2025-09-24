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
    {
      match: /meet\.google\.com/,
      browser: (url) => {
        const meetUrl = new URL(url);
        meetUrl.searchParams.set("mute", "1");
        meetUrl.searchParams.set("videooff", "1");
        return {
          name: "Google Chrome", // Google Chrome 経由で Goog Meet を開くことで正しく URL が連携される
          args: [
            "--app-id=kjgfgldnnfoeklkmfkjfagphfepbbdan", // chrome://web-app-internals/ から確認可能
            `--app-launch-url-for-shortcuts-menu-item=${meetUrl.toString()}`,
          ],
          profile: "work",
        };
      },
    },
    {
      match: [/^https?:\/\/localhost:.*$/],
      browser: {
        name: "Google Chrome Beta",
        profile: "work",
      },
    },
    {
      match: (_, options) => apps.includes(options?.opener?.bundleId ?? ""),
      browser: {
        name: "Google Chrome",
        profile: "work",
      },
    },
  ],
} satisfies FinickyConfig;
