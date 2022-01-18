import enum

class DBResultEnum(int, enum.Enum):
    SUCCESS = 0
    RULE_NOT_FOUND = 1
    USER_NOT_ALLOWED = 2
