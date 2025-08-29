<script lang="ts">
	import clsx from 'clsx';
	import type { HTMLInputAttributes } from 'svelte/elements';

	interface Props extends HTMLInputAttributes {
		label?: string;
		error?: boolean;
		hint?: string;
	}

	let {
		label,
		type,
		name,
		error,
		hint,
		class: classes,
		value = $bindable(),
		placeholder
	}: Props = $props();
</script>

<fieldset class="fieldset">
	{#if label}
		<legend class="fieldset-legend">{label}</legend>
	{/if}
	<input
		{type}
		{name}
		class={clsx('input w-full', classes)}
		bind:value
		class:input-error={error}
		{placeholder}
	/>
	{#if hint}
		<p class="label" class:text-error={error}>{hint}</p>
	{/if}
</fieldset>
