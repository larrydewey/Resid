// som.Random, the suite's deterministic generator.
pub const Random = struct {
    seed: i32 = 74755,

    pub fn next(r: *Random) i32 {
        r.seed = ((r.seed *% 1309) +% 13849) & 65535;
        return r.seed;
    }
};
