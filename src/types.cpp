#include <iostream>

#include "types.h"

namespace bpftrace {

std::ostream &operator<<(std::ostream &os, Type type)
{
  os << typestr(type);
  return os;
}

std::ostream &operator<<(std::ostream &os, const SizedType &type)
{
  os << type.type;
  if (type.is_pointer)
    os << "*";
  return os;
}

bool SizedType::operator==(const SizedType &t) const
{
  return type == t.type && size == t.size;
}

bool SizedType::IsArray() const
{
  return type == Type::string || type == Type::usym || (type == Type::cast && !is_pointer);
}

std::string typestr(Type t)
{
  switch (t)
  {
    case Type::none:     return "none";     break;
    case Type::integer:  return "integer";  break;
    case Type::hist:     return "hist"; break;
    case Type::lhist:    return "lhist";    break;
    case Type::count:    return "count";    break;
    case Type::sum:      return "sum";      break;
    case Type::min:      return "min";      break;
    case Type::max:      return "max";      break;
    case Type::avg:      return "avg";      break;
    case Type::stats:    return "stats";    break;
    case Type::stack:    return "stack";    break;
    case Type::ustack:   return "ustack";   break;
    case Type::string:   return "string";   break;
    case Type::sym:      return "sym";      break;
    case Type::usym:     return "usym";     break;
    case Type::cast:     return "cast";     break;
    case Type::name:     return "name";     break;
    default: abort();
  }
}

ProbeType probetype(const std::string &type)
{
  for (int i = 0; i < sizeof(PROBE_LIST); i++)
  {
    if (type == PROBE_LIST[i].name || type == PROBE_LIST[i].abbr)
      return PROBE_LIST[i].type;
  }
  abort();
}

std::string probetypeName(const std::string &type)
{
  for (int i = 0; i < sizeof(PROBE_LIST); i++)
  {
    if (type == PROBE_LIST[i].name || type == PROBE_LIST[i].abbr)
      return PROBE_LIST[i].name;
  }
  return "";
}

uint64_t asyncactionint(AsyncAction a)
{
  return (uint64_t)a;
}

} // namespace bpftrace
