
import pandas as pd
from collections import deque


class Node:

    def __init__(self, index):
        self._index = index
        self._next = None


class Head:

    def __init__(self):
        "Initiate an empty linked list."
        self._next = None

    def insert(self, node_new):
        "Insert the given node according to indices."
        if self.last._index <= node_new._index:
            ## If the index of the last node is smaller than the index of the
            ## given node, there is no need to check all nodes.
            self.last._next = node_new
        else:
            cur = self._next
            while True:
                if cur._next._index < node_new._index:
                    cur = cur._next
                else:
                    node_new._next = cur._next
                    cur._next = node_new
                    break

    def undock(self):
        """Undock the first node and return it. The second node become the
        first one."""
        undocked = self._next
        self._next = self._next._next

        return undocked

    def collect(self):
        cur = self._next
        dict_indices = {}
        i = 0
        while cur:
            dict_indices[i] = cur._index
            cur = cur._next
            i += 1
        n = len(dict_indices)
        indices = [dict_indices[i] for i in range(n)]
        return indices

    @property
    def last(self):
        cur = self._next
        while cur._next:
            cur = cur._next
        return cur


class Arrival(Node):

    def __init__(self, time:float):
        super().__init__(time)
        self.whe_block = 0
        self._next_arrived = None


class Leave(Node):

    def __init__(self, time:float, whi_server:int):
        super().__init__(time)
        self.whi_server = whi_server
        self._arrival = None


class Servers(Head):

    def __init__(self, f_serve, f_inter, num_servers:int=5, cap_queue:int=5):
        """Queueing system modelled by linked lists.

        Keyword Arguments
        =================
        f_serve: function to simulate service times.
        f_inter: function to simulate interarrival times, which are times
                 between consecutive arrivals.

        Notes
        =====
        There is no waiting room in this setting.
        """
        if not callable(f_serve):
            raise ValueError("Function to simulate service time is "
                "not callable.")
        if not callable(f_inter):
            raise ValueError("Function to simulate arrival sojourn time is "
                "not callable.")

        super().__init__()
        self.busys = [0 for i in range(num_servers)]
        self.num_arriveds = 0
        self.num_block = 0
        self.f_serve = f_serve
        self.f_inter = f_inter
        self.clock = 0
        self.arriveds = {0: None}

        self.cap_queue = cap_queue
        self.queue = deque()

        self.events = {}

        self.warmup()

    def warmup(self):
        """Warm up the scheduled arrivals.

        Notes
        =====
        There is no need to schedule multiple arrivals in warming up stage.
        """
        t = self.f_inter()
        self._next = Arrival(t)

        ## An arbitrage `Arrival` must be added, or there is no way to build
        ## a linked list for
        # self._next_arrived = Arrival(0)

    def schedule_arrival(self):
        """Schedule a new arrival, insert it to the event list, and return
        the index.
        """
        new = Arrival(time=self._next._index + self.f_inter())
        self.insert(new)
        return new

    def schedule_leave(self, whi_server):
        new = Leave(self._next._index + self.f_serve(), whi_server)
        self.insert(new)
        return new

    def log(self, str_log:str, whi:int=0):
        self.events[len(self.events) + 1] = {
            "time": self.clock,
            "type": str_log,
            "len_queue": len(self.queue),
            "num_arriveds": self.num_arriveds,
            "num_busys": sum(self.busys),
            "num_block": self.num_block,
            "whi_customer": whi
            }

    def arrive(self):
        """Event routine triggered when a new customer arrives.

        Notes
        =====
        Three possible outcomes:
        - served
        - join the queue
        - blocked
        """
        self.num_arriveds += 1
        whi_server = self.first_idle + 0
        if whi_server == self.num_servers:  # There is no idle server.
            if len(self.queue) == self.cap_queue:
                ## If the customer is blocked, there is no need to set a
                ## `leave` event.
                self.num_block += 1
                self._next.whe_block = 1
                self.log("arrive-block")
            else:
                self.queue.append(self.num_arriveds)
                self.log("arrive-queue")
        else:
            ## To assign the customer to the first idle server and simulate
            ## his/her leaving time.
            self.busys[whi_server] = 1
            # print(self.busys)
            self.schedule_leave(whi_server)
            self.log("arrive-serve")

        ## Next schedule
        self.schedule_arrival()

    def leave(self):
        "Event routine triggered when an existing customer leaves."
        self.busys[self._next.whi_server] = 0  # To set the server idle.
        if len(self.queue) > 0:  # There are customers in the queue.
            self.busys[self._next.whi_server] = 1
            self.schedule_leave(self._next.whi_server)
            whi = self.queue.popleft()
            self.log("leave-queue", whi)
        else:
            self.log("leave")

    def advance(self):
        "Invoke next event and advance the clock time."
        self.clock = self._next._index + 0

        if isinstance(self._next, Leave):
            self.leave()
            self.undock()
        elif isinstance(self._next, Arrival):
            self.arrive()
            docked = self.undock()
            self.arriveds[len(self.arriveds)+1] = docked
            # self.last_arrived._next_arrived = docked

        return self.clock

    @property
    def num_servers(self):
        return len(self.busys)

    @property
    def first_idle(self):
        """Return the index of the first idle server.

        Attentions
        ==========
        The indices are 0, 1, 2, ..., self.num_servers-1
        """
        result = 0
        i = 0
        while i <= self.num_servers - 1:
            if self.busys[i] == 0:
                break
            else:
                i += 1
        return i

    def collect_event_list(self):
        cur = self._next
        dict_whe_leave = {}
        i = 0
        while cur:
            dict_whe_leave[i] = isinstance(cur, Leave)
            cur = cur._next
            i += 1
        n = len(dict_whe_leave)
        whe_leaves = [dict_whe_leave[i] for i in range(n)]
        return whe_leaves

    @property
    def pd_log(self):
        return pd.DataFrame.from_dict(ser.events, orient='index')

    # @property
    # def last_arrived(self):
    #     cur = self._next_arrived
    #     while cur._next_arrived:
    #         cur = cur._next_arrived
    #     return cur

    # def collect_arriveds(self):
    #     cur = self._next_arrived
    #     indices = {}
    #     i = 0
    #     while cur:
    #         indices[i] = cur._index
    #         cur = cur._next_arrived
    #         i += 1
    #     n = len(indices)
    #     li_indices = [indices[i] for i in range(n)]
    #     return li_indices
