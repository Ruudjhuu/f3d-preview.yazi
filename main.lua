local M = {}

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache or self:preload(job) ~= 1 then
		return
	end
	ya.sleep(math.max(0, 0.1 + start - os.clock()))
	ya.image_show(cache, job.area)
	ya.preview_widget(job, {})
end

function M:seek(job, units)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = ya.clamp(-1, units, 1)
		ya.emit("peek", { math.max(0, cx.active.preview.skip + step), only_if = job.file.url })
	end
end

local function ext_of(url)
	return tostring(url):match("^.+%.([^.]+)$")
end

-- Tenta extrair a thumbnail embutida no 3mf. Devolve true se conseguiu.
local function try_extract_3mf_thumbnail(input, cache)
	-- 1. descobre o caminho real da thumbnail via _rels/.rels
	local rels = Command("unzip"):arg({ "-p", input, "_rels/.rels" }):output()
	local target
	if rels and rels.status.success then
		target = rels.stdout:match('Target="([^"]+)"[^>]*[Tt]humbnail')
			or rels.stdout:match('[Tt]humbnail[^>]*Target="([^"]+)"')
	end
	-- 2. fallback para o caminho mais comum, caso o .rels não tenha sido encontrado/lido
	target = (target or "Metadata/thumbnail.png"):gsub("^/", "")

	-- 3. extrai a imagem
	local out = Command("unzip"):arg({ "-p", input, target }):output()
	if not out or not out.status.success or #out.stdout == 0 then
		return false
	end

	return fs.write(cache, out.stdout) and true or false
end

function M:preload(job)
	ya.dbg("Preloading f3d-preview ***")
	if not job then
		return 1
	end
	local percentage = 5 + job.skip
	if percentage > 95 then
		ya.emit("peek", { 90, only_if = job.file.url, upper_bound = true })
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

	local input = tostring(job.file.url)

	-- usa a thumbnail embutida no 3mf, se existir
	if ext_of(job.file.url) == "3mf" and try_extract_3mf_thumbnail(input, cache) then
		ya.err("Used embedded thumbnail for: " .. input)
		return 1
	end

	-- caso contrário, renderiza com f3d como antes
	ya.err("Calling f3d for: " .. input .. ", cache: " .. tostring(cache))
	local child, code = Command("f3d"):arg({
		input,
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
