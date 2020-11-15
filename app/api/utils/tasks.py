from app.db.models.port import Port
from app.db.models.port_forward import PortForwardRule, MethodEnum
from app.db.schemas.port_forward import PortForwardRuleOut
from app.api.utils.tc import send_tc
from app.api.utils.gost import send_gost_rule
from app.api.utils.iptables import send_iptables_forward_rule


def trigger_forward_rule(
    rule: PortForwardRule,
    port: Port,
    old: PortForwardRuleOut = None,
    new: PortForwardRuleOut = None,
    update_gost: bool = False,
):
    print(
        f"Received forward rule:\nold:{old.__dict__ if old else None}\nnew:{new.__dict__ if new else None}"
    )
    if (new and new.method == MethodEnum.IPTABLES) or (
        old and old.method == MethodEnum.IPTABLES
    ):
        send_iptables_forward_rule(
            port.id,
            port.server.ansible_name,
            port.num,
            old,
            new,
        )

    if (new and new.method == MethodEnum.GOST) or (
        old and old.method == MethodEnum.GOST
    ):
        send_gost_rule(
            port.id,
            port.server.ansible_name,
            update_status=bool(new and new.method == MethodEnum.GOST),
            update_gost=update_gost,
        )


def trigger_tc(port: Port):
    print(f"Triggering traffic control for port: f{port.__dict__}")
    send_tc(
        port.server.ansible_name,
        port.id,
        port.num,
        port.config.get("egress_limit"),
        port.config.get("ingress_limit"),
    )
