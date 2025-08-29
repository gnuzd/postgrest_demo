<script>
	import ChatInput from './ChatInput.svelte';
	import MessageList from './MessageList.svelte';
</script>

<div class="p-2 flex flex-col h-full">
	<div class="flex-1">
		<MessageList data={[{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }]} />
	</div>

	<ChatInput />
</div>
