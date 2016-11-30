import os

def main():
    batteries = []
    if not os.path.isdir('/sys/class/power_supply'):
        return {}
    for dir_ in os.listdir('/sys/class/power_supply'):
        batteries.append(dir_)
    return {'batteries': batteries, 'alxbse': True}
