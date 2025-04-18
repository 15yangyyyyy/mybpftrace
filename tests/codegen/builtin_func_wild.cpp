#include "../mocks.h"
#include "common.h"

namespace bpftrace {
namespace test {
namespace codegen {

using ::testing::Return;

TEST(codegen, builtin_func_wild)
{
  test("kprobe:sys_* { @x = func }", NAME);
}

} // namespace codegen
} // namespace test
} // namespace bpftrace
