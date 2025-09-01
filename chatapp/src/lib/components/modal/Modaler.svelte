<script lang="ts">
	import { twMerge } from 'tailwind-merge';

	import { modal } from './store.svelte';
</script>

<dialog class={twMerge('modal', modal.state.options?.class)} open={modal.state.open}>
	<div class="modal-box">
		{#if typeof modal.state.options?.onclose === 'function'}
			<form method="dialog">
				<button
					class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2"
					onclick={() => {
						modal.state.options?.onclose?.();
						modal.close();
					}}
				>
					✕
				</button>
			</form>
		{/if}

		{#if modal.state.options?.title}
			{#if typeof modal.state.options.title === 'string'}
				<h3 class="text-lg font-bold">{modal.state.options.title}</h3>
			{:else}
				{@render modal.state.options.title()}
			{/if}
		{/if}

		{#if modal.state.component}
			<svelte:component this={modal.state.component} {...modal.state.options?.props || {}} />
		{/if}

		{#if modal.state.options?.action}
			<div class="modal-action">
				{@render modal.state.options.action()}
			</div>
		{/if}
	</div>

	{#if modal.state.options?.dismissible}
		<button class="modal-backdrop" onclick={() => modal.close()}>close</button>
	{/if}
</dialog>
