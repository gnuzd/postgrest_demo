<script>
	import { superForm } from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';
	import { Send } from '@lucide/svelte';

	import { messageSchema } from '$lib/schema';

	import Button from './Button.svelte';
	import Input from './Input.svelte';
	import { toast } from 'svelte-sonner';
	import { page } from '$app/state';

	const { onSend } = $props();

	const { form, enhance, message } = superForm(
		{ body: '', channelId: page.url.searchParams.get('channel') },
		{ validators: zodClient(messageSchema) }
	);

	message.subscribe((res) => {
		if (res?.error) {
			toast.error(res.message);
			return;
		}
		console.log('res: ', res);

		if (res?.data) {
			onSend(res.data);
		}
	});
</script>

<form method="POST" action="/actions?/createMessage" use:enhance>
	<div class="flex gap-3 items-center">
		<div class="flex-1">
			<Input name="body" class="w-full" bind:value={$form.body} />
		</div>
		<Input name="channelId" class="hidden" bind:value={$form.channelId} />
		<Button type="submit" disabled={!$form.body} class="btn-ghost btn-square">
			<Send />
		</Button>
	</div>
</form>
