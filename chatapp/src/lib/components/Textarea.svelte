<script lang="ts">
	import clsx from 'clsx';
	import type { HTMLInputAttributes, HTMLTextareaAttributes } from 'svelte/elements';

	interface Props extends HTMLTextareaAttributes {
		label?: string;
		error?: boolean;
		hint?: string;
	}

	let {
		label,
		name,
		hint,
		class: classes = 'h-24',
		value = $bindable(),
		placeholder
	}: Props = $props();
</script>

<fieldset class="fieldset">
	{#if label}
		<legend class="fieldset-legend">{label}</legend>
	{/if}
	<textarea {name} class={clsx('textarea', classes)} bind:value {placeholder}></textarea>
	{#if hint}
		<div class="label">{hint}</div>
	{/if}
</fieldset>
