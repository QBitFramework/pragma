use Test::More tests => 13;

use qbit;

is(to_json('test'), '"test"', 'Check string to JSON');

is(to_json(10.5), '10.5', 'Check number to JSON');

is(to_json(undef), 'null', 'Check undef to JSON');

is(
    to_json({key1 => [0, 1], key2 => [], key3 => {sk1 => 1, sk2 => 2}, key4 => {}}),
    '{"key2":[],"key4":{},"key1":[0,1],"key3":{"sk2":2,"sk1":1}}',
    'Check struct to JSON'
  );

is(format_number(12345678.901200, thousands_sep => ',', decimal_point => '.'),
    '12,345,678.9012', 'Checked basic format_number');

is(format_number(12345678, thousands_sep => ',', decimal_point => '.'),
    '12,345,678', 'Checked basic format_number without frac');

is(format_number(12345678.901200, thousands_sep => ',', decimal_point => '.', precision => 2),
    '12,345,678.90', 'Checked format_number with precision');

is(format_number(12345678, thousands_sep => ',', decimal_point => '.', precision => 2),
    '12,345,678.00', 'Checked basic format_number with precision without frac');

is(format_number(12345678.901200, thousands_sep => ',', decimal_point => '.', precision => 0),
    '12,345,679', 'Checked format_number with zero precision');

is(format_number(123, thousands_sep => ',', decimal_point => '.'), '123', 'Checked format_number with 3 digits number');

is(format_number(123456, thousands_sep => ',', decimal_point => '.'),
    '123,456', 'Checked format_number with 6 digits number');

is(format_number(0.000123456, thousands_sep => ',', decimal_point => '.', precision => 5),
    '0.00012', 'Checked format_number with started zero number');

is(format_number(9.87165876490036e-05, thousands_sep => ',', decimal_point => '.', precision => 5),
    '0.00001', 'Checked format_number with very small number');