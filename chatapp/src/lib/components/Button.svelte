<script lang="ts">
	import clsx from 'clsx';
	import type { Snippet } from 'svelte';
	import type { HTMLButtonAttributes } from 'svelte/elements';

	interface Props extends HTMLButtonAttributes {
		children: Snippet;
		loading?: boolean;
	}

	const { children, loading, class: classes, ...rest }: Props = $props();
</script>

<button disabled={loading} class={clsx('btn', classes)} {...rest}>
	{#if loading}
		<span class="loading loading-spinner"></span>
	{/if}

	{@render children()}
</button>
