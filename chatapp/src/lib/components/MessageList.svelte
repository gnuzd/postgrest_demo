<script lang="ts">
	const { data } = $props();
</script>

{#each data as item}
	<div class="chat" class:chat-start={true}>
		<div class="chat-bubble">
			It's over Anakin,
			<br />
			I have the high ground.
		</div>
	</div>
{/each}
