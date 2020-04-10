var add = function (x) { return function (y) { return x + y; }; };
console.log(add(2)(4));
var add2 = add(2);
console.log(add2(2));
console.log([1, 2, 3].map(add2));
