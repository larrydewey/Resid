const n = parseInt(process.argv[2]);
let s = "";
for (let i = 0; i < n; i++) s = s + String(i) + ",";
console.log(s.length);
