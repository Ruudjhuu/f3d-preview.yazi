local M = {}

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache or self:preload() ~= 1 then
		return
	end
	ya.sleep(math.max(0, 0.1 + start - os.clock()))
	ya.image_show(cache, job.area)
	ya.preview_widgets(job, {})
end

function M:seek(job, units)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = ya.clamp(-1, units, 1)
		ya.manager_emit("peek", { math.max(0, cx.active.preview.skip + step), only_if = job.file.url })
	end
end

function M:preload(job)
	ya.dbg("Preloading f3d-preview ***")
	if not job then
		return 1
	end

	local percentage = 5 + job.skip
	if percentage > 95 then
		ya.manager_emit("peek", { 90, only_if = job.file.url, upper_bound = true })
		return 2
	end
	local cache = ya.file_cache(job)
	if not cache then
		return 1
	end

	local cha = fs.cha(cache)
	if cha and cha.len > 0 then
		return 1
	end

	-- generate image
	ya.err("Calling f3d for: " .. tostring(job.file.url) .. ", cache: " .. tostring(cache))
	local child, code = Command("f3d"):arg({
		tostring(job.file.url),
		"--no-background",
		"-tas",
		"--output",
		tostring(cache),
	}):spawn()

	if not child then
		ya.err("spawn `f3d` command returns " .. tostring(code))
		return 0
	end

	local status = child:wait()
	return status and status.success and 1 or 2
end

return M
