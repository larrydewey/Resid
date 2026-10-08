// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightSidebarTopics from 'starlight-sidebar-topics';
import residGrammar from '../editors/vscode/syntaxes/resid.tmLanguage.json' with { type: 'json' };

// GitHub Pages: https://larrydewey.github.io/Resid/
export default defineConfig({
	site: 'https://larrydewey.github.io',
	base: '/Resid',
	integrations: [
		starlight({
			title: 'Resid',
			description: 'An eager compile-time programming language. What remains is what matters.',
			logo: { src: './src/assets/logo.png', alt: 'Resid' },
			favicon: '/mascot.svg',
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/larrydewey/Resid' }],
			customCss: ['./src/styles/custom.css'],
			editLink: { baseUrl: 'https://github.com/larrydewey/Resid/edit/master/website/' },
			lastUpdated: true,
			expressiveCode: { shiki: { langs: [{ ...residGrammar, name: 'resid' }] } },
			plugins: [
				starlightSidebarTopics([
					{
						label: 'Learn Resid',
						link: '/learn/',
						icon: 'open-book',
						items: [
							{ label: 'Start', items: ['learn', 'learn/install', 'learn/hello'] },
							{
								label: 'The language',
								items: [
									'learn/values',
									'learn/functions',
									'learn/control-flow',
									'learn/collections',
									'learn/types',
									'learn/errors',
									'learn/strings',
									'learn/modules',
									'learn/capabilities',
									'learn/concurrency',
									'learn/testing',
								],
							},
							{ label: 'Going further', items: ['learn/reduction', 'learn/performance', 'learn/native', 'learn/ledger', 'learn/next'] },
						],
					},
					{
						label: 'Behaviors',
						link: '/behaviors/',
						icon: 'puzzle',
						items: [
							'behaviors',
							'behaviors/ord',
							'behaviors/show',
							'behaviors/defining',
							'behaviors/generics',
							'behaviors/generic-verbs',
							'behaviors/behavioralizing',
							'behaviors/reference',
						],
					},
					{
						label: 'Reference',
						link: '/reference/',
						icon: 'document',
						items: [
							'reference',
							'reference/lexical',
							'reference/numbers',
							'reference/types',
							'reference/expressions',
							'reference/statements',
							'reference/functions',
							'reference/patterns',
							'reference/modules',
							'reference/capabilities',
							'reference/concurrency',
							'reference/fixed-capacity',
							'reference/builders',
							'reference/vectors',
							'reference/native-modules',
							'reference/reduction',
							'reference/knowledge-graph',
							'reference/provenance',
							'reference/errors',
						],
					},
					{
						label: 'Stdlib & Tools',
						link: '/tools/',
						icon: 'setting',
						items: [
							'tools',
							'tools/residc',
							'tools/stdlib',
							'tools/providers',
							'tools/http-server',
							'tools/editor',
							'tools/why-graph-debug',
							'tools/fmt-pkg',
							'tools/security',
							'tools/benchmarks',
						],
					},
				]),
			],
		}),
	],
});
