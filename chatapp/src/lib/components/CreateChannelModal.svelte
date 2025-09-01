<script lang="ts">
	import { toast } from 'svelte-sonner';
	import { superForm } from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';

	import Button from '$lib/components/Button.svelte';
	import Input from '$lib/components/Input.svelte';
	import { channleSchema } from '$lib/schema';
	import Textarea from './Textarea.svelte';
	import { modal } from './modal';

	const { onClose } = $props();

	const { form, enhance, errors, submitting, message } = superForm(
		{ name: '', description: '' },
		{ validators: zodClient(channleSchema) }
	);

	message.subscribe((res) => {
		if (res?.error) {
			toast.error(res.message);
			return;
		}

		if (res?.data) {
			onClose(res.data);
			modal.close();
		}
	});
</script>

<form class="flex flex-col" method="POST" action="/actions?/createChannel" use:enhance>
	<Input
		label="Name"
		name="name"
		error={!!$errors.name?.length}
		bind:value={$form.name}
		hint={$errors.name?.[0]}
		placeholder="Channel Name"
	/>

	<Textarea
		name="description"
		label="Description"
		class="resize-none w-full"
		bind:value={$form.description}
	/>

	<Button type="submit" loading={$submitting} class="mt-5">Create</Button>
</form>
