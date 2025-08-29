<script>
	import { Plus } from '@lucide/svelte';
	import Button from './Button.svelte';
	import ChannelItem from './ChannelItem.svelte';
	import Input from './Input.svelte';

	const { channels } = $props();

	let list = $state(channels);
</script>

<div class="p-2">
	<div class="px-2 py-1 flex gap-1.5 items-center w-full">
		<div class="flex-1">
			<Input placeholder="Search" class="bg-base-100" />
		</div>
		<Button class="btn-square btn-ghost"><Plus /></Button>
	</div>

	<div>
		{#each list as item}
			<ChannelItem data={item} />
		{/each}
	</div>
</div>
