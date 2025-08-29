<script lang="ts">
	const { data } = $props();
</script>

<div class="p-2 flex justify-between hover:bg-secondary/30 rounded cursor-pointer">
	<div class="flex gap-3 items-center">
		<img
			src={`https://api.dicebear.com/9.x/initials/svg?seed=${data.name}`}
			alt={data.name}
			class="size-12 rounded"
		/>

		<div>
			<p class="text-lg text-base-content/80 font font-semibold">{data.name}</p>
			<p class="text-sm text-base-content/70">{data.last_message}</p>
		</div>
	</div>
	<div>
		<p class="text-sm text-base-content/60">3m</p>
	</div>
</div>
