import type { Component, ComponentType, Snippet, SvelteComponent } from 'svelte';

type Options<T> = {
	props?: T;
	dismissible?: boolean;
	class?: string;
	title?: string | Snippet;
	onclose?: () => void;
	action?: Snippet;
};

type ModalState = {
	/* eslint-disable @typescript-eslint/no-explicit-any */
	/** @description type any is match with Record<string, any> */
	component: Component<any, object, ''> | ComponentType | null;
	options?: Options<object>;
	open?: boolean;
};

export class Modal {
	state = $state<ModalState>({ component: null, open: false });

	open<T extends object>(
		component: Component<T, object, ''> | ComponentType,
		options?: Options<T>
	) {
		this.state.options = options || {};
		this.state.component = component;
		this.state.open = true;
	}

	close() {
		this.state.open = false;
	}
}

export const modal = new Modal();
