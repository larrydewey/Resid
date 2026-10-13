// som.Random: the AWFY linear congruential generator.
pub struct Random { seed: i32 }

impl Random {
    pub fn new() -> Random { Random { seed: 74755 } }
    pub fn next(&mut self) -> i32 {
        self.seed = ((self.seed * 1309) + 13849) & 65535;
        self.seed
    }
}
