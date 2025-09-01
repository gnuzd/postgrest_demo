<script lang="ts">
	import { goto } from '$app/navigation';

	const { data, active } = $props();
</script>

<li>
	<a
		class="list-row p-2 flex items-center hover:bg-base-300/50"
		class:bg-base-300={active}
		href={`/?channel=${data.id}`}
		data-sveltekit-reload
	>
		<div>
			<img
				src={`https://api.dicebear.com/9.x/initials/svg?seed=${data.name}`}
				alt={data.name}
				class="size-10 rounded-box"
			/>
		</div>

		<div>
			<div class="text-lg font-semibold">{data.name}</div>
			<div class="text-xs opacity-60">Remaining Reason</div>
		</div>
	</a>
</li>
