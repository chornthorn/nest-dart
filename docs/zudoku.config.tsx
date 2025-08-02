import type { ZudokuConfig } from "zudoku";

const config: ZudokuConfig = {
  basePath: "https://chornthorn.github.io/nest-dart",
  metadata: {
    title: "Nest Dart",
    description: "NestJS-inspired dependency injection framework for Dart",
  },
  site: {
    title: "Nest Dart",
  },
  navigation: [
    {
      type: "category",
      label: "Documentation",
      collapsed: false,
      collapsible: true,
      items: [
        {
          type: "category",
          label: "Getting Started",
          icon: "sparkles",
          collapsed: false,
          collapsible: true,
          items: [
            "/introduction",
            "/getting-started",
          ],
        },
        {
          type: "category",
          label: "Guides",
          icon: "book-open",
          collapsed: false,
          collapsible: true,
          items: [
            "/core-guide",
            "/flutter-guide",
            "/frog-guide",
          ],
        },
        {
          type: "category",
          label: "Reference",
          icon: "code",
          collapsed: false,
          collapsible: true,
          items: [
            "/api-reference",
            "/examples",
            "/roadmap",
          ],
        },
        {
          type: "category",
          label: "Useful Links",
          icon: "link",
          collapsed: false,
          collapsible: true,
          items: [
            {
              type: "link",
              icon: "github",
              label: "GitHub Repository",
              to: "https://github.com/chornthorn/nest-dart",
            },
            {
              type: "link",
              icon: "message-circle",
              label: "Discussions",
              to: "https://github.com/chornthorn/nest-dart/discussions",
            },
            {
              type: "link",
              icon: "bug",
              label: "Report Issues",
              to: "https://github.com/chornthorn/nest-dart/issues",
            },
          ],
        },
      ],
    },
    {
      type: "link",
      to: "/api-reference",
      label: "API Reference",
    },
  ],
  redirects: [{ from: "/", to: "/introduction" }],
  syntaxHighlighting: {
    themes: {
      light: "github-light",
      dark: "github-dark",
    },
    languages: [
      "dart",
      "typescript",
      "javascript",
      "json",
      "yaml",
    ],
  },
  search: {
    type: "pagefind",
    ranking: {
      termFrequency: 1,
      pageLength: 1,
      termSimilarity: 1,
      termSaturation: 1,
    },
    maxResults: 10,
    maxSubResults: 5,
  },
};

export default config;