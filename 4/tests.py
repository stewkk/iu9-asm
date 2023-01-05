#!/usr/bin/env python3

import subprocess

subprocess.run(["make", "compile"], check=True)

add = [
    (0, 0),
    (1, 2),
    (-1, 2),
    (-2, 1),
    (-10, 0),
    (-355, 63),
    (355, -63),
    (355, 63),
    (-355, -63),
    (1111111111111111, 2222222222222222),
    (9999999999999999, 2222222222222222),
    (9999999999999999, 5555),
    (11111111111111111111111111, 5555555555555555555555555555555555),
    (10, -11),
    (-5, -2),
]


for tc in add:
    def run_test(lhs, rhs):
        expect = lhs + rhs
        res = subprocess.run(["./main"], input="{}\n{}\n".format(lhs, rhs), check=True, capture_output=True, text=True).stdout
        print("{} + {} = {}, expected {}".format(lhs, rhs, res.split('\n')[0], expect))
        assert "{}\n".format(expect) == res

    run_test(tc[0], tc[1])
    run_test(tc[1], tc[0])

for tc in add:
    def run_test(lhs, rhs):
        expect = lhs * rhs
        res = subprocess.run(["./main", "mul"], input="{}\n{}\n".format(lhs, rhs), check=True, capture_output=True, text=True).stdout
        print("{} * {} = {}, expected {}".format(lhs, rhs, res.split('\n')[0], expect))
        assert "{}\n".format(expect) == res

    run_test(tc[0], tc[1])
    run_test(tc[1], tc[0])
