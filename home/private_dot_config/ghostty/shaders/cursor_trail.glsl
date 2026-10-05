// Based on ghostty-shader-playground by Krone Corylus, MIT License,
// Copyright (c) 2025 Krone Corylus:
// https://github.com/KroneCorylus/ghostty-shader-playground
//
// Combined cursor smear trail + blaze glow — single pass
// Quad SDF (4 edges), one texture sample, one sqrt, dual early exit

void processEdge(vec2 p, vec2 a, vec2 b, inout float md, inout float ins) {
    vec2 e = b - a, w = p - a;
    float t = clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    vec2 d = w - e * t;
    md = min(md, dot(d, d));
    ins = min(ins, step(0.0, e.x * w.y - e.y * w.x));
}

float sdQuad(vec2 p, vec2 a, vec2 b, vec2 c, vec2 d) {
    float md = 1e20, ins = 1.0;
    processEdge(p, a, b, md, ins);
    processEdge(p, b, c, md, ins);
    processEdge(p, c, d, md, ins);
    processEdge(p, d, a, md, ins);
    float r = sqrt(max(md, 0.0));
    return mix(r, -r, ins);
}

const float DUR = 0.15;
const vec3 SMEAR_COL = vec3(1.0, 1.0, 0.0);
const vec3 BLAZE_MAIN = vec3(1.0, 0.725, 0.161);
const vec3 BLAZE_ACC = vec3(1.0, 0.0, 0.0);

// Unfocused split: no trail or glow, and the hollow box becomes a bar.
// Ghostty always draws an unfocused cursor as a hollow box with a 1px outline
// (its default cursor thickness), whatever style the terminal asked for.
const float OUTLINE_ERASE = 2.0; // covers the 1px outline with a margin
const float BAR_WIDTH = 1.0;     // matches Ghostty's own bar cursor

void unfocusedCursor(out vec4 fragColor, in vec2 fragCoord, vec4 bg) {
    fragColor = bg;
    if (iCursorVisible == 0) return;

    // iCurrentCursor.xy is the corner with the larger Y, .zw the size.
    vec2 lo = vec2(iCurrentCursor.x, iCurrentCursor.y - iCurrentCursor.w);
    vec2 hi = lo + iCurrentCursor.zw;
    if (any(lessThan(fragCoord, lo)) || any(greaterThanEqual(fragCoord, hi))) return;

    vec2 inLo = lo + OUTLINE_ERASE, inHi = hi - OUTLINE_ERASE;
    if (any(lessThan(fragCoord, inLo)) || any(greaterThanEqual(fragCoord, inHi))) {
        fragColor.rgb = iBackgroundColor;
    }
    if (fragCoord.x < lo.x + BAR_WIDTH) fragColor = vec4(iCurrentCursorColor.rgb, 1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 bg = texture(iChannel0, fragCoord / iResolution.xy);
    if (iFocus == 0) { unfocusedCursor(fragColor, fragCoord, bg); return; }

    float bp = clamp((iTime - iTimeCursorChange) / DUR, 0.0, 1.0);
    if (bp >= 1.0) { fragColor = bg; return; }

    float sc = 2.0 / iResolution.y;
    vec2 off = iResolution.xy / iResolution.y;
    vec2 nc = fragCoord * sc - off;

    vec2 cp = iCurrentCursor.xy * sc - off;
    vec2 pp = iPreviousCursor.xy * sc - off;
    vec2 cs = iCurrentCursor.zw * sc;
    vec2 ps = iPreviousCursor.zw * sc;
    vec2 hcs = cs * 0.5;
    vec2 center = cp + vec2(hcs.x, -hcs.y);
    vec2 pCenter = pp + vec2(ps.x * 0.5, -ps.y * 0.5);

    // AABB early exit — skip pixels far from trail+blaze area
    // Covers both cursor rects with margin for blaze glow
    vec2 margin = cs * 3.0;
    vec2 lo = min(cp, pp) - margin;
    vec2 hi = max(cp + cs, pp + ps) + margin;
    if (nc.x < lo.x || nc.x > hi.x || nc.y < lo.y || nc.y > hi.y) {
        fragColor = bg; return;
    }

    // Cursor rectangle SDF (shared by smear mask + blaze)
    vec2 rd = abs(nc - center) - hcs;
    float curSdf = length(max(rd, 0.0)) + min(max(rd.x, rd.y), 0.0);

    // --- Smear trail (parallelogram, 4 edges) ---
    vec2 sel = step(vec2(0.0), cp - pp);
    vec2 v0 = cp + vec2(cs.x * sel.x, -cs.y * (1.0 - sel.y));
    vec2 v1 = cp + vec2(cs.x * (1.0 - sel.x), -cs.y * sel.y);
    vec2 v2 = pp + vec2(ps.x * (1.0 - sel.x), -ps.y * sel.y);
    vec2 v3 = pp + vec2(ps.x * sel.x, -ps.y * (1.0 - sel.y));

    float ease = 1.0 - bp; ease = 1.0 - ease * ease * ease;
    v2 = mix(v2, v0, ease);
    v3 = mix(v3, v1, ease);

    float trailSdf = sdQuad(nc, v0, v1, v2, v3);
    float alpha = 1.0 - smoothstep(-sc, sc, trailSdf);

    // Squared-distance fade (no sqrt)
    float llSq = dot(center - pCenter, center - pCenter);
    vec2 dv = nc - center;
    float fade = 1.0 - smoothstep(0.0, max(llSq, 1e-6), dot(dv, dv));

    // Composite: background → smear → blaze (from smear output) → mask
    float inside = step(curSdf, 0.0);
    fragColor = bg;
    fragColor.rgb = mix(fragColor.rgb, SMEAR_COL * fade, alpha);

    // Blaze glow — derived from smear-modified output
    float t = 1.0 - bp; t = t * t * t;
    float outer = max(curSdf, 0.0);
    float blazeEdge = smoothstep(0.0, outer + 0.002, 0.004);
    vec3 blaze = mix(fragColor.rgb, BLAZE_ACC, blazeEdge);
    blaze = mix(blaze, BLAZE_MAIN, blazeEdge);
    float blazeAlpha = smoothstep(0.0, outer * outer + 1e-6, t * t * llSq);

    fragColor.rgb = mix(fragColor.rgb, blaze, blazeAlpha);
    fragColor.rgb = mix(fragColor.rgb, bg.rgb, inside);
}
