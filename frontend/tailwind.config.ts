import type { Config } from 'tailwindcss';

/**
 * Design tokens are defined as CSS variables in src/styles/theme.css.
 * The Tailwind theme references those variables so that the accent
 * switcher (navy / burgundy / forest) re-themes utilities automatically.
 */
export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        bg: 'var(--bg)',
        cream: 'var(--cream)',
        surface: 'var(--surface)',
        'surface-2': 'var(--surface-2)',
        line: 'var(--border)',
        ink: 'var(--ink)',
        muted: 'var(--muted)',
        // accent — re-themable
        navy: 'var(--navy)',
        gold: 'var(--accent-2)',
        // member-status palette
        status: {
          permanent: 'var(--status-permanent)',
          associe: 'var(--status-associe)',
          doctorant: 'var(--status-doctorant)',
          retraite: 'var(--status-retraite)',
          ancien: 'var(--status-ancien)',
        },
      },
      fontFamily: {
        serif: ['var(--font-serif)'],
        sans: ['var(--font-sans)'],
        mono: ['var(--font-mono)'],
      },
      borderRadius: {
        DEFAULT: '2px',
      },
      maxWidth: {
        content: '1280px',
      },
      keyframes: {
        liasFade: { from: { opacity: '0' }, to: { opacity: '1' } },
        liasRise: {
          from: { opacity: '0', transform: 'translateY(8px)' },
          to: { opacity: '1', transform: 'none' },
        },
      },
      animation: {
        fade: 'liasFade 0.2s ease',
        rise: 'liasRise 0.22s ease',
      },
    },
  },
  plugins: [],
} satisfies Config;
