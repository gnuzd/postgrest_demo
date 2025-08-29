<script lang="ts">
	import '../app.css';
	import { Toaster } from 'svelte-sonner';
	import favicon from '$lib/assets/favicon.svg';
	import Modaler from '$lib/components/modal/Modaler.svelte';

	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<Toaster richColors />
<Modaler />
<div class="flex flex-col h-dvh w-full">
	{@render children?.()}
</div>
