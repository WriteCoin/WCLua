const add = (x: number) => (y: number) => x+y

console.log(add(2)(4))

const add2 = add(2)

console.log(add2(2))

console.log([1,2,3].map(add2))