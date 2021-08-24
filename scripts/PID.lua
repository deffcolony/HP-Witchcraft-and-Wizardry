-- PID implementation by Iaobardar. 
-- A system controller to smoothely provide input to shift the system from where it is to where it needs to be.
-- https://en.wikipedia.org/wiki/PID_controller

PID_k = {}
PID_h = {}

function init_PID(ID, kp, ki, kd, min, max)
	PID_k[ID] = {p = kp, i = ki, d = kd, min = min or -1, max = max or 1}
	PID_h[ID] = {i_p = 0, sum = 0}
end

function PID(ID, i, t)
	local rel = t - i
	local k = PID_k[ID]
	local h = PID_h[ID]
	h.sum = clamp(h.sum + rel * k.i, k.min, k.max)
	local r = (rel * k.p) + h.sum + (k.d * (h.i_p - i))
	h.i_p = i
	return clamp(r, k.min, k.max)
end

function clamp(a, min, max)
	return (a > min) and ((a < max) and a or max) or min
end