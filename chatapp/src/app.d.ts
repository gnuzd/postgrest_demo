// See https://svelte.dev/docs/kit/types#app.d.ts

import type Api from '$lib/api';

// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		interface Locals {
			api?: Api;
			user?: { id: string; email: string };
		}
		// interface PageData {}
		// interface PageState {}
		// interface Platform {}
	}
}

export {};
