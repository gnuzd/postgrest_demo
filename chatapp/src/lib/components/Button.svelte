<script lang="ts">
	import clsx from 'clsx';
	import type { Snippet } from 'svelte';
	import type { HTMLButtonAttributes } from 'svelte/elements';

	interface Props extends HTMLButtonAttributes {
		children: Snippet;
	}

	const { children, class: classes, ...rest }: Props = $props();
</script>

<button class={clsx('btn', classes)} {...rest}>
	{@render children()}
</button>
