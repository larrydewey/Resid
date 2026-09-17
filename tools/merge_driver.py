#!/usr/bin/env python3
"""Regenerate examples/driver.resid from examples/codegen.resid + examples/typecheck.resid.

Recipe (M6 stage-2):
  base   = codegen.resid minus CLI bits (pick_out, Int main)
  chunk  = typecheck.resid from its Environment banner onward, minus Int main,
           with colliding names renamed ck_* / sigs_empty / Sigs and shared
           helpers (parse_type, skip_body, skip_decl, str_find_char, op_prec,
           type PRes) deduped out
  tail   = existing driver.resid driver section (pick_opt + main) with the
           declare-header list refreshed from codegen.resid's main
"""
import re
import sys

ROOT = __file__.rsplit('/tools/', 1)[0]

DECL = re.compile(r'^(?:type )?(?:[A-Z][A-Za-z]*|List\(Str\)|Str|Int|Bool|Void)\s+(\w+)\s*[\({]')


def read(p):
    return open(f"{ROOT}/{p}").read().split('\n')


def decl_ranges(lines):
    """[(start, end_inclusive, name)] for top-level decls."""
    out, i = [], 0
    while i < len(lines):
        m = DECL.match(lines[i])
        if m and not lines[i].startswith('//'):
            j = i
            while j < len(lines) and lines[j] != '}':
                j += 1
            out.append((i, min(j, len(lines) - 1), m.group(1)))
            i = j + 1
        else:
            i += 1
    return out


def drop_decls(lines, names):
    ranges = decl_ranges(lines)
    kill = set()
    for (a, b, n) in ranges:
        if n in names:
            kill.update(range(a, b + 1))
    return [l for k, l in enumerate(lines) if k not in kill]


def rename_chunk(text):
    pairs = [
        (r'\benv_lookup_rev\b', 'ck_env_lookup_rev'),
        (r'\benv_lookup_at\b', 'ck_env_lookup_at'),
        (r'\benv_lookup\b', 'ck_env_lookup'),
        (r'\benv_add\b', 'ck_env_add'),
        (r'\bfn_index_at\b', 'ck_fn_index_at'),
        (r'\bfn_index\b', 'ck_fn_index'),
        (r'\bstruct_index_at\b', 'ck_struct_index_at'),
        (r'\bstruct_index\b', 'ck_struct_index'),
        (r'\bcollect_sigs_at\b', 'ck_collect_sigs_at'),
        (r'\bcollect_sigs\b', 'ck_collect_sigs'),
        (r'\bcollect_ptypes\b', 'ck_collect_ptypes'),
        (r'\bcheck_program\b', 'ck_check_program'),
        (r'\bop_prec\b', 'ck_op_prec'),
        (r'\bb_index_at\b', 'ck_b_index_at'),
        (r'\bb_index\b', 'ck_b_index'),
        (r'\bfuncs_empty\b', 'sigs_empty'),
        (r'\bFuncs\b', 'Sigs'),
    ]
    for pat, rep in pairs:
        text = re.sub(pat, rep, text)
    return text


def cut_main(lines):
    ranges = decl_ranges(lines)
    for (a, b, n) in ranges:
        if n == 'main':
            return lines[:a]
    return lines


def main():
    cg = read('examples/codegen.resid')
    tc = read('examples/typecheck.resid')
    dv = read('examples/driver.resid')

    # 1. base: codegen without CLI
    base = drop_decls(cg, {'pick_out'})
    base = cut_main(base)
    while base and base[-1].strip() == '':
        base.pop()

    # 2. chunk: typecheck checker section
    cs = next(i for i, l in enumerate(tc) if 'Environment' in l)
    # include preceding blank separation cleanly
    chunk = tc[cs:]
    chunk = cut_main(chunk)
    chunk = drop_decls(chunk, {
        'PRes', 'parse_type', 'parse_type_arg',
        'parse_type_args_rest', 'skip_body', 'skip_decl',
        'str_find_char',
        # Constraint-type helpers (spec §12): identical copies
        # in both halves; keep the codegen (base) versions.
        'find_sqclose_d', 'find_semi0', 'extract_ctext',
        'ct_is_at', 'ct_is', 'ct_rank_at', 'ct_rank',
        # Parameter name collection: codegen has its own
        'collect_pnames',
        'ct_base_of', 'ct_text_of',
        # Fixed-capacity type predicates (spec §44):
        # identical copies in both halves; keep the
        # codegen (base) versions.
        'is_str_fixed', 'is_bytes_fixed', 'is_list_fixed',
        'fixed_elem', 'fixed_cap', 'is_fixed_type',
        '_all_digits',
        # Behavior helpers: identical copies in both
        # halves; keep the codegen (base) versions.
        'behavior_decl_at', 'read_instance',
        'strip_reverse',
        # Sandbox capability-list parsing (spec §21):
        # identical copies in both halves; keep the
        # codegen (base) versions. (The checker's
        # richer family/readonly/meet-caps helpers
        # used for enforcement are NOT duplicated in
        # codegen and so are not in this list.)
        'cap_list_at', 'ceil_join'
    })
    chunk_t = rename_chunk('\n'.join(chunk)).split('\n')

    # 3. tail: minimal driver entry point (imports + helpers + pick_opt + main)
    # extracted fresh from old driver, NOT carried over verbatim (old driver
    # accumulates stale intermediate functions between merges).
    ds = next(i for i, l in enumerate(dv) if 'Driver:' in l)
    tail = dv[ds:]
    # Refresh hdr_core/header from codegen's main (same as before)
    cg_main_start = next(a for (a, b, n) in decl_ranges(cg) if n == 'main')
    cg_hdr_core = None
    cg_header = None
    cg_main_lines = cg[cg_main_start:]
    i = 0
    while i < len(cg_main_lines):
        l = cg_main_lines[i]
        stripped = l.strip()
        if stripped.startswith('List(Str) hdr_core ='):
            parts = [l]
            j = i
            while not cg_main_lines[j].rstrip().endswith('];'):
                j += 1
                parts.append(cg_main_lines[j])
            cg_hdr_core = ' '.join(p.strip() for p in parts)
            i = j
        if stripped.startswith('List(Str) header ='):
            cg_header = l
            break
        i += 1
    if cg_hdr_core is None:
        raise SystemExit('merge_driver: no hdr_core line found in codegen main')
    if cg_header is None:
        raise SystemExit('merge_driver: no header line found in codegen main')
    # Replace hdr_core/header in the extracted tail
    replaced_core = False
    replaced_header = False
    new_tail = []
    for l in tail:
        stripped = l.strip()
        if stripped.startswith('List(Str) hdr_core =') and not replaced_core:
            new_tail.append(cg_hdr_core)
            replaced_core = True
        elif stripped.startswith('List(Str) header =') and not replaced_header:
            new_tail.append(cg_header)
            replaced_header = True
        else:
            new_tail.append(l)
    if not replaced_core:
        raise SystemExit('merge_driver: no hdr_core line found in driver tail')
    if not replaced_header:
        raise SystemExit('merge_driver: no header line found in driver tail')
    tail = new_tail

    banner = ['', '// =====================================================================',
              '// Checker stage - fused from typecheck.resid (ck_-prefixed where',
              '// colliding with the codegen stage above). Regenerated by',
              '// tools/merge_driver.py - do not edit by hand.',
              '// =====================================================================', '']

    out = base + banner + chunk_t + [''] + tail
    open(f'{ROOT}/examples/driver.resid', 'w').write('\n'.join(out) + '\n')
    print(f"wrote examples/driver.resid ({len(out)} lines)")


if __name__ == '__main__':
    main()