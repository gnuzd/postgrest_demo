<script>
	import { page } from '$app/state';
	import ChannelList from '$lib/components/ChannelList.svelte';
	import ChatPane from '$lib/components/ChatPane.svelte';

	const { data } = $props();
</script>

<div class="flex h-full p-2">
	<div class="flex-1 bg-base-300/20 rounded max-w-80">
		<ChannelList channels={data.channels} me={data.user} />
	</div>

	{#key page.url.searchParams.get('channel')}
		<div class="flex-1">
			<ChatPane messages={data.messages} me={data.user} />
		</div>
	{/key}
</div>
