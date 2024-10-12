import urllib
import json
import pprint
import numpy as np
import matplotlib.pyplot as plt

np.seterr(invalid='ignore')
url = "https://ec2instances.info/instances.json"
# url = "file:///home/cosgroma/workspace/envision/scripts/instances.json"

region = "us-west-2"
os = "linux"
ptype = "ondemand"

ksa = [
    "ECU",
    "storage",
    "memory",
    "ebs_throughput",
    "ebs_iops",
    # "ebs_max_bandwidth",
    # "FPGA",
    "vCPU",
    # "GPU"
]


def get_stroage(storage):
  value = storage["size"] * storage["devices"]
  if storage["ssd"]:
    value *= 2
  return value


def get_price(pricing, region, os, ptype):
  price = float(pricing[region][os][ptype])
  return price


def get_ec2_data(url):
  response = urllib.urlopen(url)
  instances = json.loads(response.read())
  return instances


def isPrimitive(obj):
  return isinstance(obj, (int, float, bool, str, unicode)) or obj is None


def filter_tree(tree):
  # print(tree.keys())
  # del(tree["previous"])
  # print(tree.keys())
  return tree


def get_instance_tree(ksa, instances):

  tree = dict()
  max_values = dict()
  for i, k in enumerate(ksa):
    max_values[k] = list()
    for j, instance in enumerate(instances):

      g = instance["generation"]
      f = instance["family"]

      if g not in tree.keys():
        tree[g] = dict()
      if f not in tree[g].keys():
        tree[g][f] = np.zeros((len(ksa), len(instances), 2))

      try:
        price = get_price(instance["pricing"], region, os, ptype)
        value = instance[k] if instance[k] is not None else 0
        if isinstance(value, (str, unicode)):
          value = np.nan
        elif k == "storage" and instance[k] is not None:
          value = get_stroage(instance[k])
      except Exception as e:
        print(instance["pretty_name"])

      tree[g][f][i, j, :] = [value, price]

      max_values[k].append(value)

    max_values[k] = max(max_values[k])
  tree = filter_tree(tree)
  return tree, max_values


def plot_metrics(instance_tree, max_values):

  num_generations = len(instance_tree.keys())
  num_families = max([len(instance_tree[g].keys()) for g in instance_tree.keys()])
  axes = []
  # fig = plt.figure()
  for i in range(0, num_generations):

    fig, ax = plt.subplots(1, num_families, sharey=True, sharex=True, squeeze=True)
    # ax = fig.add_subplot(1, num_families, sharey=True, sharex=True, squeeze=True)
    axes.append(ax)

  for m, g in enumerate(instance_tree.keys()):
    for n, f in enumerate(instance_tree[g].keys()):
      axes[m][n].set_title('%s\n%s' % (f, g))
      for i, k in enumerate(ksa):
        x = instance_tree[g][f][i, :, 0]
        y = instance_tree[g][f][i, :, 1]
        try:
          x = x / max_values[k]
        except Exception as e:
          pass

        z = np.array(zip(x, y))
        axes[m][n].semilogy(z[:, 0], z[:, 1], '*C%d' % (i,), ms=10, label=k)
        axes[m][n].grid(True)
        axes[m][n].set_xlabel('Normalized Metric')
        axes[m][n].set_ylabel('Price/Hour ($)')
        plt.minorticks_on()
    axes[m][0].legend(loc='best', bbox_to_anchor=(0, 1))
  plt.show()


def main():

  ec2_instances = get_ec2_data(url)
  instance_tree, max_values = get_instance_tree(ksa, ec2_instances)

  plot_metrics(instance_tree, max_values)

if __name__ == '__main__':
  main()
