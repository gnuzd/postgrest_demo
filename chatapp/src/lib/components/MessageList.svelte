<script lang="ts">
	import { Info } from '@lucide/svelte';

	const { messages, me } = $props();
</script>

<div role="alert" class="alert alert-vertical sm:alert-horizontal">
	<Info class="text-secondary" />
	<span>Join to see messages.</span>
	<div>
		<button class="btn btn-sm btn-secondary">Accept</button>
	</div>
</div>

{#each messages as item}
	<div class="chat" class:chat-end={item.user_id === me.id}>
		<div class="chat-image avatar">
			<div class="w-10 rounded-full">
				<img
					alt="Tailwind CSS chat bubble component"
					src={`https://api.dicebear.com/9.x/initials/svg?seed=${item.users?.email}`}
				/>
			</div>
		</div>
		<div class="chat-bubble">
			{item.content}
		</div>
	</div>
{/each}
