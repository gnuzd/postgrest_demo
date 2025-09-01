<script>
	import { Plus } from '@lucide/svelte';
	import Button from './Button.svelte';
	import ChannelItem from './ChannelItem.svelte';
	import Input from './Input.svelte';
	import { modal } from './modal';
	import CreateChannelModal from './CreateChannelModal.svelte';
	import { page } from '$app/state';

	const { channels } = $props();

	let list = $state(channels);
</script>

<div class="flex flex-col h-full">
	<div class="px-4 py-3 flex gap-1.5 items-center w-full">
		<div class="flex-1">
			<Input placeholder="Search" class="bg-base-100" />
		</div>
		<Button
			class="btn-square btn-ghost"
			onclick={() =>
				modal.open(CreateChannelModal, {
					dismissible: true,
					title: 'Create Channel',
					props: { onClose: (data) => (list = [data, ...list]) }
				})}
		>
			<Plus />
		</Button>
	</div>

	<ul class="list px-2">
		{#each list as item}
			<ChannelItem data={item} active={item.id === page.url.searchParams.get('channel')} />
		{/each}
	</ul>
</div>
