<script>
	import { Send, SendHorizonal } from '@lucide/svelte';
	import Button from './Button.svelte';
	import Input from './Input.svelte';
</script>

<div class="flex gap-3 items-center">
	<div class="flex-1">
		<Input class="w-full" />
	</div>
	<Button class="btn-ghost btn-square">
		<SendHorizonal />
	</Button>
</div>
